{
  lib,
  writers,
  symlinkJoin,
  makeWrapper,
  nix,
  git,
  coreutils,
}:
let
  name = "tack-diff";
  runtimeInputs = builtins.attrValues { inherit nix git coreutils; };
  runtimePath = lib.makeBinPath runtimeInputs;

  nuScript = writers.writeNuBin name ''
    def main [] {
    	let lock_path = ".tack/pins.lock.json"

    	if not ($lock_path | path exists) {
    		print -e $"Error: no lock file found at ($lock_path)"
    		exit 1
    	}

    	print "Fetching current lock and remote HEADs..."
    	let lock_data = (open $lock_path)
    	for name in ($lock_data | columns) {
    		let item = ($lock_data | get -o $name)
    		let type = ($item | get -o type)
    		let local_rev = ($item | get -o rev)

    		let repo_url = if ($type | is-empty) or ($type == "git") {
    			$item | get url
    		} else {
    				$"https://($type).com/($item | get owner)/($item | get repo)"
    		}

    		if ($repo_url | is-empty) or ($local_rev | is-empty) { continue }

    		let ref_target = if "ref" in $item {
    			$item.ref | str replace "refs/heads/" ""
    		} else { "HEAD" }

    		let ls_output = (
    			^git ls-remote --exit-code $repo_url $ref_target
    			| ls-remote-to-hash
    		)
    		
    		if ($ls_output | is-empty) {
    			print $"(ansi y) Unable to resolve remote head for ($name)(ansi reset)"
    			continue
    		}

    		if $local_rev != $ls_output {
    			print ""
    			print $"· (ansi b)($name)(ansi reset)"
    			print $"URL: ($repo_url)"
    			print $"Branch: ($ref_target)"
    			print $"Current: ($local_rev | str substring 0..7)"
    			print $"Remote: (ansi g)($ls_output | str substring 0..7)(ansi reset)"
    			print $"Compare: ($repo_url)/compare/($local_rev)...($ls_output)"
    			print ""
    		} else {
    			print $"· (ansi b)($name)(ansi reset) is up to date."
    		}
    	}
    }

    def ls-remote-to-hash [] {
    	let input_text = $in | str trim
    	if ($input_text | is-empty) { return "" }
    	($input_text | split row (char tab) | first | str trim)
    }
  '';
in
symlinkJoin {
  inherit name;
  paths = [ nuScript ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/${name} \
      --prefix PATH : "${runtimePath}"
  '';
  meta.mainProgram = name;
}

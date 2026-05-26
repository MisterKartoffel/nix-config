let
  GBToBytes = GB: GB * 1024 * 1024 * 1024;
in
{
  zramSwap = {
    enable = true;
    memoryMax = GBToBytes 4;
  };
}

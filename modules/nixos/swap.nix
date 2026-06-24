let
  GBToBytes = GB: GB * 1024 * 1024 * 1024;
in
{
  zramSwap.memoryMax = GBToBytes 4;
}

int intFromBytes(List<int> bytes ) {
  int value = 0;
  for (int i = 0; i < bytes.length; i++) {
    assert (bytes[i] >= 0 && bytes[i] <= 255);
    value = value << 8 | bytes[i];
  }
  return value;
}
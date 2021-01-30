{
  deep_clone = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "003iqvmxxcm7p6qr2aafi1p5djm6ycvwzrjk6shc9wvybkvbckmz";
      type = "gem";
    };
    version = "0.0.1";
  };
  textmate_grammar = {
    groups = ["default"];
    platforms = [];
    source = {
      path = ./gem;
      type = "path";
    };
    version = "0.0.0";
  };
}
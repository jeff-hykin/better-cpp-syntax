{ lib, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
    pname = "salt";
    version = "v0.2.3";

    src = fetchFromGitHub {
        owner = "Milo123459";
        repo = pname;
        rev = version;
        sha256 = "1d17lxz8kfmzybbpkz1797qkq1h4jwkbgwh2yrwrymraql8rfy42";
    };

    cargoSha256 = "1615z6agnbfwxv0wn9xfkh8yh5waxpygv00m6m71ywzr49y0n6h6";

    meta = with lib; {
        description = "Fast and simple task management from the CLI.";
        homepage = "https://github.com/Milo123459/salt";
        license = licenses.mit;
        maintainers = [ ];
    };
}
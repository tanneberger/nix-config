{ ... }: {
  bahn-bingo = {
    enable = true;
    http = {
      port = 9012;
      host = "127.0.0.1";
    };
    pictureFolder = "/var/lib/bahn-bingo/pictures/";
    # we dont set bingoTemplate and bingoFieldConfig so it uses the one from the repo
    domains = {
      websiteDomain = "bahn.bingo";
      apiDomain = "api.bahn.bingo";
      filesDomain = "files.bahn.bingo";
    };
  };
}

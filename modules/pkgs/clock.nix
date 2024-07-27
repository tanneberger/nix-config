{ lib
, mkDerivation
, fetchFromGitHub
, jdk11_headless
, cmake
, gcc
, boost
, mpg321
, coreutils
, which
, procps
}:
let

  lfc = mkDerivation {
    pname = "lfc";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "revol-xut";
      repo = "lingua-franca-nix-releases";
      rev = "11c6d5297cd63bf0b365a68c5ca31ec80083bd05";
      sha256 = "DgxunzC8Ep0WdwChDHWgG5QJbJZ8UgQRXtP1HZqL9Jg=";
    };

    buildInputs = [ jdk11_headless ];

    _JAVA_HOME = "${jdk11_headless}/";

    postPatch = ''
      substituteInPlace bin/lfc \
        --replace 'base=`dirname $(dirname ''${abs_path})`' "base='$out'" \
        --replace "run_lfc_with_args" "${jdk11_headless}/bin/java -jar $out/lib/jars/org.lflang.lfc-0.1.0-SNAPSHOT-all.jar"
    '';

    installPhase = ''
      cp -r ./ $out/
      chmod +x $out/bin/lfc
    '';

    meta = with lib; {
      description = "Polyglot coordination language";
      longDescription = ''
        Lingua Franca (LF) is a polyglot coordination language for concurrent
        and possibly time-sensitive applications ranging from low-level
        embedded code to distributed cloud and edge applications.
      '';
      homepage = "https://github.com/lf-lang/lingua-franca";
      license = licenses.bsd2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ revol-xut ];
    };
  };

  # downloading the cpp runtime
  cpp-runtime = mkDerivation {
    name = "cpp-lingua-franca-runtime";

    src = fetchFromGitHub {
      owner = "lf-lang";
      repo = "reactor-cpp";
      rev = "007143225dbc198a5fee233ce125c3584a9541d8";
      sha256 = "sha256-wiBTJ4jSzoAu/Tg2cMqMWv7qZD29F+ysDOOF6F/DLJM=";
    };

    nativeBuildInputs = [ cmake gcc ];

    configurePhase = ''
      echo "Configuration"
    '';

    buildPhase = ''
      mkdir -p build
      cd build
      cmake .. -DCMAKE_INSTALL_PREFIX=./
      make install
    '';

    installPhase = ''
      cp -r ./ $out/
    '';

    fixupPhase = ''
      echo "FIXUP PHASE SKIP"
    '';
  };

  music-repo = fetchGit {
    url = "https://gitea.tassilo-tanneberger.de/revol-xut/alarm-clock-music.git";
    rev = "2209f66ef64e5776ad976b506412efcd702a7fa8";
  };

in
mkDerivation {
  name = "alarm-clock";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "revol-xut";
    repo = "lf-alarm-clock";
    rev = "aec632914960cffa8405dbec9ddd6186eee93799";
    sha256 = "sha256-zpnL1/0et8HTuVWPEJ+hRWq6VYgDFjJxygu40rlvGaE=";
    fetchSubmodules = true;
  };

  buildInputs = [ lfc gcc cmake boost mpg321 which ];

  patchPhase = ''
    substituteInPlace src/shared_header.hpp \
      --replace '~/music/AlarmClock/' '${music-repo}/' \
      --replace './alarm_clock_events.csv' '/home/lf-alarm-clock/alarm_clock_events.csv' \
      --replace 'mpg321' '${mpg321}/bin/mpg321' \
      --replace 'kill' '${coreutils}/bin/kill' \
      --replace 'pidof' '${procps}/bin/pidof'
  '';

  configurePhase = ''
    echo "SKIPPING CONFIGURATION PHASE";
  '';

  buildPhase = ''
    cmake --version
    mkdir -p include/reactor-cpp/
    cp -r ${cpp-runtime}/include/reactor-cpp/* include/reactor-cpp/
    ${lfc}/bin/lfc --external-runtime-path ${cpp-runtime}/ src/AlarmClock.lf
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./bin/* $out/bin/
  '';
}


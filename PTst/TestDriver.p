machine TestWithUnchangingTerms {
    start state Init {
        entry {
            SetupClientServerSystem();
        }
    }
}

fun SetupClientServerSystem() {
    var termsServerVersion: int;
    var levelServerVersion: int;
    var termsServer: TermsServer;
    var levelServer: LevelServer;
    var userId: int;

    termsServerVersion = 1;
    levelServerVersion = 1;


    termsServer = new TermsServer(termsServerVersion);
    levelServer = new LevelServer(levelServerVersion);

    userId = 0;
    new Client((
        termsServer=termsServer,
        levelServer=levelServer,
        userId=userId)
    );
}
machine TestWithUnchangingTerms {
    start state Init {
        entry {
            SetupClientServerSystem();
        }
    }
}

fun SetupClientServerSystem() {
    var currentTerms: int;
    var termsServerVersion: int;
    var levelServerVersion: int;
    var termsServer: TermsServer;
    var levelServer: LevelServer;
    var versionSetterServer: VersionSetterServer;
    var userId: int;

    currentTerms = 1;
    termsServerVersion = currentTerms;
    levelServerVersion = currentTerms;

    termsServer = new TermsServer(termsServerVersion);
    levelServer = new LevelServer(levelServerVersion);
    versionSetterServer = new VersionSetterServer((
        termsServer=termsServer,
        levelServer=levelServer,
        currentTerms=currentTerms)
    );

    userId = 0;
    new Client((
        termsServer=termsServer,
        levelServer=levelServer,
        userId=userId)
    );
}
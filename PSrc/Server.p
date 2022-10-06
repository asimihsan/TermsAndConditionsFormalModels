event WaitForGetTermsRequests;

event WaitForAcceptTermsRequests;

event WaitForUpdateTermsVersion;

type tUpdateTermsVersion = (source: VersionSetterServer, termsVersion: int);

event eUpdateTermsVersion: tUpdateTermsVersion;

event MaybeUpdateTermsVersion;
event UpdateTermsVersion;

machine TermsServer {
    var termsCurrent: int;

    start state Init {
        entry (termsCurrentInput: int) {
            termsCurrent = termsCurrentInput;
            goto WaitForGetTermsRequests;
        }
    }

    state WaitForGetTermsRequests {
        on eGetTermsReq do (req: tGetTermsReq) {
            send req.source, eGetTermsResp, (
                userId = req.userId,
                termsVersion = termsCurrent
            );
        }

        on eUpdateTermsVersion do (req: tUpdateTermsVersion) {
            termsCurrent = req.termsVersion;
        }
    }
}

machine LevelServer {
    var termsCurrent: int;

    start state Init {
        entry (termsCurrentInput: int) {
            termsCurrent = termsCurrentInput;
            goto WaitForAcceptTermsRequests;
        }
    }

    state WaitForAcceptTermsRequests {
        on eAcceptTermsReq do (req: tAcceptTermsReq) {
            send req.source, eAcceptTermsResp, (
                userId = req.userId,
                termsAccepted = req.termsVersion,
                termsCurrent = termsCurrent
            );
        }

        on eUpdateTermsVersion do (req: tUpdateTermsVersion) {
            termsCurrent = req.termsVersion;
        }
    }
}

machine VersionSetterServer {
    var termsServer: TermsServer;
    var levelServer: LevelServer;
    var currentTerms: int;

    start state Init {
        entry (input: (termsServer: TermsServer,
                       levelServer: LevelServer,
                       currentTerms: int)) {
            termsServer = input.termsServer;
            levelServer = input.levelServer;
            currentTerms = input.currentTerms;
            goto MaybeUpdateTermsVersion;
        }
    }

    state MaybeUpdateTermsVersion {
        entry {
            var newTerms: int;
            newTerms = currentTerms + 1;
            if ($) {
                send levelServer, eUpdateTermsVersion, (source = this, termsVersion = newTerms);
                send termsServer, eUpdateTermsVersion, (source = this, termsVersion = newTerms);
                currentTerms = newTerms;
                goto MaybeUpdateTermsVersion;
            }
        }
    }
}
// get terms request type, from client to static webpage
type tGetTermsReq = (
    source: Client,
    userId: int
);

// get terms response type, what the static webpage is
type tGetTermsResp = (
    userId: int,
    termsVersion: int
);

// accept terms request type, from client to server
type tAcceptTermsReq = (
    source: Client,
    userId: int,
    termsVersion: int
);

type tAcceptTermsResp = (
    userId: int,
    termsAccepted: int,
    termsCurrent: int
);

// event: get terms (from client to static webpage)
event eGetTermsReq: tGetTermsReq;

// event: get terms response (from static webpage to client)
event eGetTermsResp: tGetTermsResp;

// event: accept terms (from client to server)
event eAcceptTermsReq: tAcceptTermsReq;

// event: accept terms response (from server to client)
event eAcceptTermsResp: tAcceptTermsResp;

machine Client {
    var termsServer: TermsServer;
    var levelServer: LevelServer;
    var userId: int;
    var seenTermsVersion: int;

    start state init {
        entry (input: (termsServer: TermsServer,
                       levelServer: LevelServer,
                       userId: int)) {
            termsServer = input.termsServer;
            levelServer = input.levelServer;
            userId = input.userId;
            goto GetTerms;
        }
    }

    state GetTerms {
        entry {
            send termsServer, eGetTermsReq, (
                source = this,
                userId = userId
            );
        }

        on eGetTermsResp do (resp: tGetTermsResp) {
            seenTermsVersion = resp.termsVersion;
            goto AcceptTerms;

        }
    }

    state AcceptTerms {
        entry {
            send levelServer, eAcceptTermsReq, (
                source = this,
                userId = userId,
                termsVersion = seenTermsVersion
            );
        }

        on eAcceptTermsResp do (resp: tAcceptTermsResp) {
            assert resp.termsAccepted <= resp.termsCurrent,
                format("Accepted terms {0} larger than new terms {1}!",
                    resp.termsAccepted,
                    resp.termsCurrent);
        }
    }
}
event WaitForGetTermsRequests;

event WaitForAcceptTermsRequests;

event IncrementTermsOnTermsServer;

machine TermsServer {
    var termsCurrent: int;

    start state Init {
        entry (termsCurrentInput: int) {
            termsCurrent = termsCurrentInput;
            goto WaitForGetTermsRequests;
        }
    }

    state WaitForGetTermsRequests {
        entry {
            if ($) {
                send this, IncrementTermsOnTermsServer;
            }
        }

        on eGetTermsReq do (req: tGetTermsReq) {
            send req.source, eGetTermsResp, (
                userId = req.userId,
                termsVersion = termsCurrent
            );
        }

        on IncrementTermsOnTermsServer do {
            termsCurrent = termsCurrent + 1;
            goto WaitForGetTermsRequests;
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
    }
}
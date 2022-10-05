all: POutput/netcoreapp3.1/Output/TermsAndConditions.dll

test: POutput/netcoreapp3.1/Output/TermsAndConditions.dll
	coyote test POutput/netcoreapp3.1/TermsAndConditions.dll  \
		-m \
		PImplementation.tcUnchangingTerms.Execute \
		-i 1000

clean:
	rm -rf POutput/netcoreapp3.1/Output/TermsAndConditions.dll

POutput/netcoreapp3.1/Output/TermsAndConditions.dll:
	pc -proj:TermsAndConditions.pproj

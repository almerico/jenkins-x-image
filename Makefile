RELEASE_VERSION := $(shell cat VERSION)

tag:
	git add --all
	git commit -m "release $(RELEASE_VERSION)" --allow-empty # if first release then no verion update is performed
	git tag -fa v$(RELEASE_VERSION) -m "Release version $(RELEASE_VERSION)"
	git push origin v$(RELEASE_VERSION)
	
updatebot/push-version:
	@echo Doing updatebot push-version.....
	updatebot push-version --kind maven \
		org.activiti.dependencies:activiti-dependencies $(RELEASE_VERSION) \
		org.activiti.api:activiti-api-dependencies $(RELEASE_VERSION) \
		org.activiti.core.common:activiti-core-common-dependencies $(RELEASE_VERSION)

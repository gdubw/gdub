#!/usr/bin/env bash

GW=${PWD}/../../bin/gw
GRADLEW=${PWD}/../../gradlew
GRADLE="gradle"

if [ -x ${GRADLEW} ]; then
# gradlew from rootProject should find both speeches
gradlewSpeakInRootProject=$(${GRADLEW} speak)
echo $gradlewSpeakInRootProject | grep "rootProjectSpeak" || \
	{ echo "FAILED: gradlew failed to find rootProjectSpeak running from rootProject";exit 1; }
echo $gradlewSpeakInRootProject | grep "subprojectSpeak" || \
	{ echo "FAILED: gradlew failed to find subprojectSpeak running from rootProject";exit 1; }
fi

# gradle from rootProject should find both speeches
gradleSpeakInRootProject=$(${GRADLE} speak)
echo $gradleSpeakInRootProject | grep "rootProjectSpeak" || \
	{ echo "FAILED: gradlew failed to find rootProjectSpeak running from rootProject";exit 1; }
echo $gradleSpeakInRootProject | grep "subprojectSpeak" || \
	{ echo "FAILED: gradlew failed to find subprojectSpeak running from rootProject";exit 1; }

# gw from rootProject should find both speeches
gwSpeakInRootProject=$(${GW} speak)
echo $gwSpeakInRootProject | grep "rootProjectSpeak" || \
	{ echo "FAILED: gw failed to find rootProjectSpeak running from rootProject";exit 1; }
echo $gwSpeakInRootProject | grep "subprojectSpeak" || \
	{ echo "FAILED: gw failed to find subprojectSpeak running from rootProject";exit 1; }

# and again from subproject
cd subproject

if [ -x ${GRADLEW} ]; then
# gradlew from subproject should find only subproject speeches
gradlewSpeakInSubproject=$(${GRADLEW} speak)
echo $gradlewSpeakInSubproject | grep "rootProjectSpeak" && \
	{ echo "FAILED: gradlew found rootProjectSpeak running from subproject";exit 1; }
echo $gradlewSpeakInSubproject | grep "subprojectSpeak" || \
	{ echo "FAILED: gradlew failed to find subprojectSpeak running from subproject";exit 1; }
fi

# gradle from subproject won't find rootProject speeches
gradleSpeakInSubproject=$(${GRADLE} speak)
echo $gradleSpeakInSubproject | grep "rootProjectSpeak" && \
	{ echo "FAILED: gradle found rootProjectSpeak running from subproject";exit 1; }

# gw from subproject should find only subproject speeches
gwSpeakInSubproject=$(${GW} speak)
echo $gwSpeakInSubproject | grep "rootProjectSpeak" && \
	{ echo "FAILED: gw found rootProjectSpeak running from subproject";exit 1; }
echo $gwSpeakInSubproject | grep "subprojectSpeak" || \
	{ echo "FAILED: gw failed to find subprojectSpeak running from subproject";exit 1; }

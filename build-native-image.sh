./gradlew assemble
native-image \
  --no-fallback \
  --report-unsupported-elements-at-runtime \
  --enable-all-security-services \
  --class-path build/libs/micronaut-data-jdbc-graal-atp-*-all.jar
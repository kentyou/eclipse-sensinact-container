# Docker image for Eclipse sensiNact by Kentyou

Eclipse sensiNact is an Open Source framework that aims at creating a common environment in which heterogeneous devices can exchange information and interact among each other in the IoT world.

This repository provides the `Dockerfile` to construct a Docker image for Eclipse sensiNact using its distributed ZIP file.
The image is based on distroless Java.

## Usage

1. Build the image for a version of an Eclipse sensiNact distribution (`0.0.2-SNAPSHOT` by default)
   ```bash
   docker build -t "sensinact:$VERSION" --build-arg "version=$VERSION" .
   ```
2. Prepare a sensiNact environment:
   * Setup features (for example in the `ext-features` folder)
   * Setup a repository (for example, `ext-repository`)
   * Setup the configuration file (`configuration.json`), which **must** at least:
     * Contain the `"core-feature"` item in `sensinact.launcher/features`
     * Contain the `"features"` item in `sensinact.launcher/featureDir`
     * Contain the `"repository"` item in `sensinact.launcher/repository`
3. Run the Docker container, mounting the prepared environment:
   ```bash
   docker run -d --name sensinact \
       -v ${PWD}/configuration.json:/opt/sensinact/configuration/configuration.json \
       -v ${PWD}/ext-features:/opt/sensinact/ext-features \
       -v ${PWD}/ext-repository:/opt/sensinact/ext-repository \
       sensinact:$VERSION
   ```

**Note:** Do not forget to enable standard input (`-i`) when using the Gogo shell feature.

### Example

In this example, we will configure a sensiNact instance that matches the [quick start tutorial](https://eclipse-sensinact.readthedocs.io/en/latest/getting-started.html).
The final environment is available in the [`example`](example/) folder.

1. Build the image for a version of an Eclipse sensiNact distribution (`0.0.2-SNAPSHOT` by default)
   ```bash
   docker build -t "sensinact:$VERSION" --build-arg "version=$VERSION" .
   ```
2. Create the [`ext-features`](example/ext-features) folder and write the [Weather feature](https://eclipse-sensinact.readthedocs.io/en/latest/getting-started.html#configure-the-weather-feature) in the [`weather-feature.json`](example/ext-features/weather-feature.json) file
3. Create a POM file to [generate the repository](https://eclipse-sensinact.readthedocs.io/en/latest/getting-started.html#download-and-add-the-required-bundles) of additional JAR files. It should write the repository in the `ext-repository` folder. See the [example POM file](./example/pom.xml).

   **Note:** make sure the `sensinact.version` property in the POM file is compatible with the version of the Docker image.
4. Generate the repository: `mvn clean prepare-package`
5. Write the [`configuration.json`](example/configuration.json) file, with REST and HTTP Device Factory features and configuration. The important entries here are `features`, `featureDir` and `repository` in the `sensinact.launcher` entry, which must contain both the core sensiNact entries and the additional ones:

   ```json
   {
     // ...
     "sensinact.launcher": {
       "features": [
         "core-feature",
         // ...
       ],
       "repository": [
         "repository",
         "ext-repository"
       ],
       "featureDir": [
         "features",
         "ext-features"
       ]
     }
   }
   ```

6. Run the Docker image, giving access to port 8080 to access the HTTP northbound:

   ```bash
   docker run -d --name sensinact \
       -v ${PWD}/configuration.json:/opt/sensinact/configuration/configuration.json \
       -v ${PWD}/ext-features:/opt/sensinact/ext-features \
       -v ${PWD}/ext-repository:/opt/sensinact/ext-repository \
       -p 8080:8080 \
       sensinact:$VERSION
   ```

   **Note:** You can also use the provided composition file: `docker compose -f example/compose.yaml up -d`

7. Test the HTTP northbound:
   ```bash
   # List registered providers
   curl http://localhost:8080/sensinact/providers

   # Get the temperature
   curl http://localhost:8080/sensinact/providers/grenoble-weather/services/weather/resources/temperature/GET
   ```

## Links

* Eclipse sensiNact:
  * [Documentation](https://eclipse-sensinact.readthedocs.io/)
  * [Github](https://github.com/eclipse/org.eclipse.sensinact.gateway/)

plugins {
    id("java")
}

group = "fr.sandro642.github"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.eclipse.jgit:org.eclipse.jgit:6.5.0.202303070854-r")
    implementation("io.projectreactor:reactor-core:3.6.9")
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
}

tasks.test {
    useJUnitPlatform()
}


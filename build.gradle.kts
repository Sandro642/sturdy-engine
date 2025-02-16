plugins {
    id("java")
}

group = "fr.sandro642.github"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    implementation("io.projectreactor:reactor-core:3.6.9")
}

tasks.test {
    useJUnitPlatform()
}


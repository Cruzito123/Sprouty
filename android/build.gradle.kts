// ------------------------------------------------------
// 🔹 Repositorios globales del proyecto
// ------------------------------------------------------
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ------------------------------------------------------
// 🔹 Configuración de build/ personalizada (opcional)
// ------------------------------------------------------
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// ------------------------------------------------------
// 🔹 Tarea clean
// ------------------------------------------------------
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

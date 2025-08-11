import Foundation

// Define a struct to hold the pipeline configuration
struct PipelineConfig {
    let projectName: String
    let environment: String
    let repositories: [String]
    let credentials: [String: String]
}

// Define a class to generate the DevOps pipeline
class DevOpsPipelineGenerator {
    let config: PipelineConfig
    
    init(config: PipelineConfig) {
        self.config = config
    }
    
    func generatePipeline() -> String {
        // Define the pipeline template
        let template = """
        #!/bin/bash
        
        # Set environment variables
        PROJECT_NAME='${projectName}'
        ENVIRONMENT='${environment}'
        
        # Clone repositories
        {{ foreach repository in repositories }}
        git clone {{ repository }}
        {{ end }}
        
        # Set credentials
        {{ foreach credential in credentials }}
        export {{ credential.key }}={{ credential.value }}
        {{ end }}
        
        # Run pipeline stages
        {{ foreach stage in pipelineStages }}
        {{ stage }}
        {{ end }}
        """
        
        // Replace placeholders with actual values
        var pipelineScript = template
            .replacingOccurrences(of: "{{ projectName }}", with: config.projectName)
            .replacingOccurrences(of: "{{ environment }}", with: config.environment)
            .replacingOccurrences(of: "{{ foreach repository in repositories }}", with: config.repositories.map { "git clone \($0) \n" }.joined())
            .replacingOccurrences(of: "{{ foreach credential in credentials }}", with: config.credentials.map { "export \($0.key)='\($0.value)' \n" }.joined())
        
        // Add pipeline stages (e.g. build, test, deploy)
        let buildStage = """
        echo "Building project..."
        # Build project command
        """
        let testStage = """
        echo "Testing project..."
        # Test project command
        """
        let deployStage = """
        echo "Deploying project..."
        # Deploy project command
        """
        
        pipelineScript += """
        pipelineStages=( "${buildStage}" "${testStage}" "${deployStage}" )
        """
        
        return pipelineScript
    }
}

// Example usage
let config = PipelineConfig(
    projectName: "MyProject",
    environment: "dev",
    repositories: ["https://github.com/user/repo1.git", "https://github.com/user/repo2.git"],
    credentials: ["TOKEN": "my_secret_token", "KEY": "my_secret_key"]
)

let generator = DevOpsPipelineGenerator(config: config)
let pipelineScript = generator.generatePipeline()

print(pipelineScript)
### What is Chef?
- A scalable automation platform that configures and manages infrastructure, like hardware.
- Turns infrastructure into code, meaning you can test

### How does Chef work?
- Create custom recipes and upload to a Chef server.
- Recipes implement policies, like a blueprint that fits your needs, and are combined into "pluggable" cookbooks.
- Each "step" in the script is modelled as a "resource".
- Store current and desired states of infrastructure.  
- Chef Client runs on all your servers and regularly checks in with Chef server.
- Uses Ruby as Domain Specific Language (DSL)

### Chef Setup and Berkshelf
- Berkshelf is a public cookbook repo, and Berksfile contains only the location to the public cookbook repo source.
- List dependencies in metadata.rb and run ```berks vendor ..```  in cookbooks/my_cookbook to properly download books locally.

### How does AWS Opsworks come into this discusssion?
- Recipes are scripts Opsworks to run.
- Opsworks does not manage external cookbooks for you.

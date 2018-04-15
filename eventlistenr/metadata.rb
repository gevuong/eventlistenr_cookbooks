# This file is similar to package.json.
# Contains cookbook name, description, etc.
name        "eventlistenr"
description "Installs Eventlistenr"
maintainer  "Gene"
license     "Apache 2.0"
version     "1.0.0"

# contains external cookbook dependencies
depends 'apt', '= 6.1.4'
depends 'ruby-ng'
depends 'nodejs'
depends 'postgres'
depends 'nginx'
depends 'unicorn'

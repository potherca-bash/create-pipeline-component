# Create Pipeline Component

Script to create a boilerplate repository for a new [Pipeline Component][1]

[![Example][2]][3]

## Install

```sh
wget https://github.com/potherca-bash/create-pipeline-component/blob/HEAD/dist/create_component.bash
```

## Usage

```
==============================================================================
                         CREATE PIPELINE COMPONENT REPO
------------------------------------------------------------------------------
 This script will create a boilerplate repository for a new Pipeline Component
 and push it to Pipeline Components on GitLab. If the remote [repository does
 not yet exist][6], it will be created )as a private project.

 Usage:

     create_component <target-path> <package-name> [source-repo]

 Where:

    <target-path>   Is the path where the repo should be created. This should
                    include the name of the component
    <package-name>  The human readable name of the component
    [source-repo]   The skeleton repository that should be used as source

 Usage example:

     create_component ./xmllint 'XML Lint'
===============================================================================
```

## Contributing

Ask questions or give feedback by [opening an issue][4].

Code changes can be suggested by opening a [pull-request][5].

## License

Created by [Potherca][7], Licensed under a [Mozilla Public License 2.0][6] (MPL-2.0)

[1]: https://pipeline-components.dev/
[2]: ./example.svg
[3]: https://asciinema.org/a/gOSqDA1PcNTzCM7KlTRkqFxxA
[4]: https://github.com/potherca-bash/create-pipeline-component/issues
[5]: https://github.com/potherca-bash/create-pipeline-component/pulls
[6]: ./LICENSE
[7]: https://Pother.ca

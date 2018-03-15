# Repo manifest for OP-TEE development

In the OP-TEE project we try to gather all technical documentation under the
[optee_os](https://github.com/OP-TEE/optee_os) git and the build related
instructions for full setups at [build](https://github.com/OP-TEE/build).

Having that said, there are a couple of guidelines and rules that we want to
try to follow when it comes to managing the manifests in this git.

# 1. Remotes
Since most of our projects can be found on GitHub, we are using that as the main
remote. If you need to include other remotes for some reason, then that is OK,
but please double check of there is any **maintained** (and preferably
official) mirror for the project at GitHub before adding a new remote.

# 2. Layout of contents
#### 2.1 Sections
To have some kind of structure of the files, we have split them up in three
sections, one for pure OP-TEE gits, one for OP-TEE supporting gits found at
linaro-swg and then a third, `misc` section where everything else can be found.
I.e., a template looks like this (this also includes the default remote for
clarity):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
        <remote name="github" fetch="https://github.com" />

        <default remote="github" revision="master" />

        <!-- OP-TEE gits -->
        <!-- linaro-swg gits -->
        <!-- Misc gits -->
</manifest>
```

#### 2.2 Project XML elements
All `<projects ... >` lines should be on the format as shown below with the
attributes in this order. The reason for this is to have it uniformly done
across all manifests and that it will make it easier when comparing various
versions of manifests with diff tools. All three attributes are **mandatory**.
The only exception is `revision` which does not have to be stated if it is
`master` that we are tracking.

```xml
        <project path="name_and_path_on_disk" name="upstream_name.git" revision="git_revsion" />
```
#### 2.3 Alphabetic order
Within each of the three sections, all `<project ... >` lines shall be sorted in
alphabetic order (this is again for making it easier to diff manifests). The
only expection here is `build.git` which uses the `linkfile` element. Having
that at the end makes it look cleaner.

#### 2.4 Additional XML attributes
If you are using another remote than the default, then that should come
**after** the `revision` attribute (this is true for all attributes other than
the `path`, `name` and `revision`).

#### 2.5 Alignment of XML attributes
The three mandatory XML attributes `path`, `name` and `revision` should be
column aligned. Alignment of additional XML attributes are optional.

#### 2.6 When to use clone-depth="1"?
With `clone-depth="1"` you are telling `repo` and `git` that you only want a
certain commit and not the entire git log history. You can only use this under
two conditions and that is when `revision` is either a branch or a tag. Pure
`SHA-1's` does not work and will even raise `repo` and `git` sync errors in
some cases. So, the rules are, if you use either `revision="refs/tags/my_tag"`
or `revision="refs/heads/my_branch"`, then you shall add `clone-depth="1"` right
after the `revision` attribute.

#### 2.7 Spaces or tabs?
Only use spaces!

#### 2.8 Example showing the basis for an OP-TEE manifest
Here are fictive names etc, but it describes everything said above.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
        <remote name="github" fetch="https://github.com" />
        <remote name="other" fetch="https://someotherlocation.com" />

        <default remote="github" revision="master" />

        <!-- OP-TEE gits -->
        <project path="optee_abc" name="OP-TEE/optee_abc.git" />
        <project path="optee_def" name="OP-TEE/optee_def.git" />

        <!-- linaro-swg gits -->
        <project path="lswg_abc"  name="linaro-swg/lswg-abc.git" revision="aaaabbbbcccc93e64c2fdd6ae8b0be14a8c45719" />
        <project path="lswg_def"  name="linaro-swg/lswg-def.git" revision="ddddeeeeffff83e64c2fdd6ae8b0be14a8c45719" />

        <!-- Misc gits -->
        <project path="my_other"  name="my_other.git"            revision="refs/tags/2017.11" clone-depth="1" remote="other" />
</manifest>

```

# Android repo manifest for OP-TEE development
**To be merged with OP-TEE/README.md**

## 1. Install repo
Follow the instructions under the "Installing Repo" section
[here](https://source.android.com/source/downloading.html).

## 2. Get the source code
```
$ mkdir -p $HOME/devel/optee
$ cd $HOME/devel/optee
$ repo init -u https://github.com/OP-TEE/manifest.git -m ${TARGET}.xml [-b ${BRANCH}]
$ repo sync
```

### 2.1 Targets
* QEMU: default.xml
* FVP: fvp.xml
* Hikey: hikey.xml
* MediaTek MT8173 EVB Board: mt8173-evb.xml

### 2.2 Branches
Currently we are only using one branch, i.e, the master branch.

### 2.3 Get the toolchains
```
$ cd build
$ make toolchains
```

**Notes**<br>
* The folder could be at any location, we are just giving a suggestion by
  saying `$HOME/devel/optee`.
* `repo sync` can take an additional parameter -j to sync multiple remotes. For
   example `repo sync -j3` will sync three remotes in parallel.

## 3. QEMU
After getting the source and toolchain, just run:
```
$ make all run
```
and everything should compile and at the end QEMU should start.

## 4. FVP
After getting the source and toolchain you must also get the get Foundation
Model
([link](http://www.arm.com/products/tools/models/fast-models/foundation-model.php))
and untar it to the forest root, then just run:
```
$ make all run
```
and everything should compile and at the end FVP should start.

## 5. Hikey
After running `make` above, follow the instructions at
[flash-binaries-to-emmc](https://github.com/96boards/documentation/wiki/HiKeyUEFI#flash-binaries-to-emmc-)
to flash all the required images to and boot the board.

Location of files/images mentioned in the link above:
* ```$HOME/devel/optee/burn-boot/hisi-idt.py```
* ```$HOME/devel/optee/l-loader/l-loader.bin```
* ```$HOME/devel/optee/l-loader/ptable.img```
* ```$HOME/devel/optee/arm-trusted-firmware/build/hikey/release/fip.bin```
* ```$HOME/devel/optee/out/boot-fat.uefi.img```

## 6. MT8173-EVB
After getting the source and toolchain, please run:

```
$ make all run
```

When `< waiting for device >` prompt appears, press reset button

# Tips and tricks
## Reference existing project to speed up repo sync
Doing a `repo init`, `repo sync` from scratch can take a fair amount of time.
The main reason for that is simply because of the size of some of the gits we
are using, like for the Linux kernel and EDK2. With repo you can reference an
existing forest and by doing so you can speed up repo sync to instead taking ~20
seconds instead of an hour. The way to do this are as follows.

1. Start by setup a clean forest that you will not touch, in this example, let
   us call that `optee-ref` and put that under for `$HOME/devel/optee-ref`. This
   step will take roughly an hour.
2. Then setup a cronjob (`crontab -e`) that does a `repo sync` in this folder
   particular folder once a night (that is more than enough).
3. Now you should setup your actual tree which you are going to use as your
   working tree. The way to do this is almost the same as stated in the
   instructions above, the only difference is that you reference the other local
   forest when running `repo init`, like this
   ```
   repo init -u https://github.com/OP-TEE/manifest.git --reference /home/jbech/devel/optee-ref
   ```
4. The rest is the same above, but now it will only take a couple of seconds to
   clone a forest.

Normally step 1 and 2 above is something you will only do once. Also if you
ignore step 2, then you will still get the latest from official git trees, since
repo will also check for updates that aren't at the local reference.

## Use ccache
ccache is a tool that caches build object-files etc locally on the disc and can
speed up build time significantly in subsequent builds. On Debian-based systems
(Ubuntu, Mint etc) you simply install it by running:
```
$ sudo apt-get install ccache
```

The helper makefiles are configured to automatically find and use ccache if
ccache is installed on your system, so other than having it installed you don't
have to think about anything.

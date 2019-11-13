# How to build custom Grassbian image?

Place create `./config` file. The sensible minimal one might look like
the following:

```
IMG_NAME=CustomGrassbian
HOSTNAME=grassbian
```

`HOSTNAME` is optional but it will be randomly-generated otherwise.

If interested in building a full desktop version please remove `SKIP`
and `SKIP_IMAGES` files from all stages.

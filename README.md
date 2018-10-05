# visualize-org-commits
Wrapper around gource that visualizes commits from all of your org's public repositories on GitHub

[![Winding Tree commit visualization](https://media.giphy.com/media/Y4rTKc3J6MRACU4FVl/giphy.gif)](https://www.youtube.com/watch?v=cSblZNuaEAY)

(Click through to see video on https://youtu.be/cSblZNuaEAY)

# Dependencies

The `do-video.sh` script dependes on:

- bash
- [curl](https://curl.haxx.se/)
- [python](https://www.python.org/) (2 and 3 should both work)
- [git](https://git-scm.com/)
- [gource](https://github.com/acaudwell/Gource)
- [ffmpeg](https://www.ffmpeg.org/)

You can probably get all of these in distros your software repository.
I have no idea if this might work on Mac or Windows.

# Usage

1. Edit the ORGANIZATION variable in `do-video.sh` script. That's the GitHub organization handle.
1. Edit the BGR variable in `do-video.sh` script. That's path to an image that will be used as video background.
1. Optionally edit the BASE_PATH variable in `do-video.sh` script. That controls where the repositories are cloned.

And run the script:

```
$ ./do-video.sh
```

The script clones all of the organization's public GitHub repositories to a `BASE_PATH` location
or does a `git pull` if repo is already cloned there. Then `gource` generates a log for each
repository and then generates a video out of the combined logs. The video is encoded by ffmpeg

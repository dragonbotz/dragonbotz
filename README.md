# Prerequisites
To build the project, you need to install the followings first:
- [make](https://www.gnu.org/software/make/)
- [git](https://git-scm.com/)
- [docker](https://www.docker.com/)

# Quick Build
To build the whole project, run the following command:
```bash
$ make all
```

## Character service build
To build the character service, run:
```bash
$ make service-character
```

## Cleaning builder images
Builder images are heavy, it is recommended to remove those if you do not need 
them anymore.

To do so, please run the following command:
```bash
$ make clear-images-builder
```

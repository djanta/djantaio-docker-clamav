# docker-clamav-server

[![build status badge](https://img.shields.io/travis/djanta/docker-clamav-server/master.svg)](https://travis-ci.org/djanta/docker-clamav-server/branches)

> 0.0.1-SNAPSHOT

A one paragraph description about the container.

## Getting Started

These instructions will cover usage information and for the docker container 

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Start Container Parameters

List the different parameters available to your container

```shell
docker run djantaio/clamav-server:[version] parameters
```

One example per permutation 

```shell
docker run -name clamav -p "3310:3310" -it djantaio/clamav-server:[version]
```

####  Interacting with your container

Show how to get a shell started in your container too

```shell
docker run djantaio/clamav-server:[version] bash
```

or by running docker exec

```shell
docker exec -ti [container] bash
```

#### Stop Container Parameters

Show how to get a stop in your container

```shell
docker stop [container] 
```

## Built With

* debian:jessie-slim:latest
* gosu v1.10

## Find Us

* [GitHub](https://github.com/djanta/docker-clamav-server)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/djanta/docker-clamav-server/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the 
[tags on this repository](https://github.com/your/repository/tags). 

## Authors

* **Stanislas Koffi ASSOUTOVI** - *Initial work* - [Clamav](https://github.com/stanislaska)

See also the list of [contributors](https://github.com/djanta/docker-clamav-server/contributors) who 
participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/djanta/docker-clamav-server/blob/master/LICENSE) file for details.


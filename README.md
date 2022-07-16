# etl-003_transform

# Development (running locally)

```sh
docker run --rm \
	-v $(pwd)/src:/etl/src \
	--name etl_demo \
	etl-003_transform:develop


docker run --rm \
	-v $(pwd)/src:/etl/src \
    -v $(pwd)/zz_alpha.txt:/tmp/batch.txt \
	--name etl_demo \
	etl-003_transform:develop
```

# Docker Image Development & Publication

## Build
```sh
docker build -t etl-003_transform:develop -f ./Dockerfile .
```
## Run
```sh
docker run --rm \
	-v $(pwd)/src/input:/etl/src/input \
	-v $(pwd)/src/output:/etl/src/output \
	--name etl_demo \
	etl-003_transform:develop

docker run --rm \
	-v $(pwd)/src/input:/etl/src/input \
	-v $(pwd)/src/output:/etl/src/output \
    -v $(pwd)/zz_alpha.txt:/tmp/batch.txt \
	--name etl_demo \
	etl-003_transform:develop
```

## Release
```sh
docker tag \
	etl-003_transform:develop \
	etl-003_transform:latest
```

## Publish
```sh
docker push etl-003_transform:latest
```


requirements
	zips only
		contain shp and prj
	filename:
		${TABLE_NAME}-remainder.zip (will be prefixed with gis by processor)

## To run

```docker-compose up --build```

This will setup 
`kafka`, `consumer`, and `publisher`

Publisher will publish messages about 10 users 10 times.
Consumer will gather it into one hash and log it in STDOUT

## To remove all

`docker-compose down -v --remove-orphans` 

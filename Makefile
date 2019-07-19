construir:
	elm make src/Git.elm --output=build/index.html

deploy:
	surge build

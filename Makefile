HAXE=haxe
SWFMILL=swfmill
SWFMILL_FLAGS=simple
SOURCES=Clippy.hx ButtonUp.hx ButtonDown.hx ButtonOver.hx

all: clean build-dep build

build: compile.hxml $(SOURCES)

build-dep: library.swf
	mkdir -p build/

library.swf:
	$(SWFMILL) $(SWFMILL_FLAGS) library.xml library.swf

compile.hxml: $(SOURCES)
	$(HAXE) compile.hxml

clean:
	rm -rf library.swf build/

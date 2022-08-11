PYTHON3 ?= python3
ENV ?= . $(shell pwd)/venv/bin/activate; \
    PYTHONPATH=$(shell pwd)

.PHONY: start
start: venv soundfont/touhou.sf2
	$(ENV) python3 src/main.py

.PHONY: pipeline
pipeline: venv soundfont/touhou.sf2
	# TODO automatically obtain the pipeline graph
	# See https://gstreamer.freedesktop.org/documentation/tutorials/basic/debugging-tools.html?gi-language=c#getting-pipeline-graphs
	$(ENV) GST_DEBUG_DUMP_DOT_DIR=/tmp python3 src/main.py
	dot -Tpng /tmp/pipeline.dot > /tmp/pipeline.png
	xdg-open /tmp/pipeline.png

venv: requirements.txt
	$(PYTHON3) -m venv $@
	$(ENV) $(PYTHON3) -m pip install wheel -r $<
	touch $@  # update timestamp

soundfont/touhou.sf2:
	mkdir -p soundfont
	wget musical-artifacts.com/artifacts/433/Touhou.sf2 -O $@

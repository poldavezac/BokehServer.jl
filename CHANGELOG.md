# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2022-07-29

### Changed
- Compilation time is reduced by a factor 2.
- Support for creating stand-alone HTML documents: use `BokehServer.html`
instead of `BokehServer.serve`.
- The glyph API now supports positional/keyword arguments, similar in their
behavior to `python`'s. One can call `line([1,2,3].^2)` or `line(; x = [1,2,3].^2)`.

## [0.1.0] - 2022-07-25

First release: a server and every type of plot.

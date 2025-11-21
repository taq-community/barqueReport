# Images Directory

This directory contains images used in the barqueReport package templates.

## Cover Image

Place your custom cover image here and reference it in the YAML front matter of your `.qmd` file:

```yaml
cover-image: "path/to/your/cover-image.jpg"
```

### Recommended specifications:
- Format: PNG, JPG, or PDF
- Dimensions: A4 paper size (210mm x 297mm) or higher resolution
- Resolution: 300 DPI for print quality
- Orientation: Portrait

### Example usage:

If you save an image as `inst/images/cover.jpg`, reference it in your report as:

```yaml
cover-image: !expr system.file("images/cover.jpg", package = "barqueReport")
```

Or use an absolute path:

```yaml
cover-image: "/path/to/your/image.jpg"
```

## Default Background

If no cover image is specified, the template will use a default blue gradient background.

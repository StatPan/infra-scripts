# Go Installation Script

This directory contains the Go (Golang) language installation script. You can install Go on your system by running `install.sh`.

## What is Go?

Go is a statically typed, compiled language developed by Google. It features fast build times, simple syntax, and built-in concurrency support.

It is mainly used in the following areas:

- Server and network programming
- Web service backend
- Cloud infrastructure (e.g., Docker and Kubernetes are written in Go)
- CLI tool development, etc.

## Installation Method

```bash
./install.sh            # Install the latest version
./install.sh go1.22.4   # Install a specific version
```

After installation, open a new shell or run `source ~/.bashrc` or `source ~/.zshrc` to apply environment variables.

## Usage Example

Check if Go is installed:

```bash
go version
```

Create a new project:

```bash
mkdir hello-go && cd hello-go
go mod init hello-go
```

Create a file (`main.go`):

```go
package main

import "fmt"

func main() {
  fmt.Println("Hello, Go!")
}
```

Run:

```bash
go run main.go
```
package main

import (
	"expvar"
	"fmt"
	"net/http"
	"os"
	"github.com/mdlayher/vsock"
)

func main() {
	port := uint32(8080)

	cid, err := vsock.ContextID()
	if err != nil {
		panic(err)
	}
	
	lis, err := vsock.Listen(port, nil)
	if err != nil {
		panic(err)
	}

	val, ok := os.LookupEnv("GIT_URL")
	if ok {
		expvar.NewString("git_url").Set(val)
	}

	val, ok = os.LookupEnv("GIT_REV")
	if ok {
		expvar.NewString("git_rev").Set(val)
	}
	
	fmt.Fprintf(os.Stderr,
		"HTTP server started on vsock cid %d port %d\n",
		cid, port)
	
	http.Serve(lis, nil)
}

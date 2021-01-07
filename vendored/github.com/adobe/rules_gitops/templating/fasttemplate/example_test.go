package fasttemplate

import (
	"fmt"
	"io"
	"net/url"
)

func ExampleTemplate() {
	template := "http://{{host}}/?foo={{bar}}{{bar}}&q={{query}}&baz={{baz}}"

	// Substitution map.
	// Since "baz" tag is missing in the map, it will be left unchanged.
	m := map[string]interface{}{
		"host": "google.com",     // string - convenient
		"bar":  []byte("foobar"), // byte slice - the fastest

		// TagFunc - flexible value. TagFunc is called only if the given
		// tag exists in the template.
		"query": TagFunc(func(w io.Writer, tag string) (int, error) {
			return w.Write([]byte(url.QueryEscape(tag + "=world")))
		}),
	}

	s := ExecuteString(template, "{{", "}}", m)
	fmt.Printf("%s", s)

	// Output:
	// http://google.com/?foo=foobarfoobar&q=query%3Dworld&baz={{baz}}
}

func ExampleTemplateWithSpaces() {
	template := "http://{{ host }}/?foo={{ bar }}{{ bar }}&q={{ query }}&baz={{ baz }}"

	// Substitution map.
	// Since "baz" tag is missing in the map, it will be substituted
	// by an empty string.
	m := map[string]interface{}{
		"host": "google.com",     // string - convenient
		"bar":  []byte("foobar"), // byte slice - the fastest

		// TagFunc - flexible value. TagFunc is called only if the given
		// tag exists in the template.
		"query": TagFunc(func(w io.Writer, tag string) (int, error) {
			return w.Write([]byte(url.QueryEscape(tag + "=world")))
		}),
	}

	s := ExecuteString(template, "{{", "}}", m)
	fmt.Printf("%s", s)

	// Output:
	// http://google.com/?foo=foobarfoobar&q=query%3Dworld&baz={{ baz }}
}

func ExampleTagFunc() {
	template := "foo[baz]bar"
	bazSlice := [][]byte{[]byte("123"), []byte("456"), []byte("789")}
	m := map[string]interface{}{
		// Always wrap the function into TagFunc.
		//
		// "baz" tag function writes bazSlice contents into w.
		"baz": TagFunc(func(w io.Writer, tag string) (int, error) {
			var nn int
			for _, x := range bazSlice {
				n, err := w.Write(x)
				if err != nil {
					return nn, err
				}
				nn += n
			}
			return nn, nil
		}),
	}

	s := ExecuteString(template, "[", "]", m)
	fmt.Printf("%s", s)

	// Output:
	// foo123456789bar
}

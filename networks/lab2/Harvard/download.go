package main

import (
	"github.com/mgutz/logxi/v1"
	"golang.org/x/net/html"
	"net/http"
)

func getAttr(node *html.Node, key string) string {
	for _, attr := range node.Attr {
		if attr.Key == key {
			return attr.Val
		}
	}
	return ""
}

func getChildren(node *html.Node) []*html.Node {
	var children []*html.Node
	for c := node.FirstChild; c != nil; c = c.NextSibling {
		children = append(children, c)
	}
	return children
}

func isElem(node *html.Node, tag string) bool {
	return node != nil && node.Type == html.ElementNode && node.Data == tag
}

func isText(node *html.Node) bool {
	return node != nil && node.Type == html.TextNode
}

func isDiv(node *html.Node, class string) bool {
	return isElem(node, "div") && getAttr(node, "class") == class
}

func isSection(node *html.Node, class string) bool {
	return isElem(node, "section") && getAttr(node, "class") == class
}

func isArticle(node *html.Node, class string) bool {
	return isElem(node, "article") && getAttr(node, "class") == class
}

func isA(node *html.Node, class string) bool {
	return isElem(node, "a") && getAttr(node, "class") == class
}
type Item struct {
	Ref, Time, Title string
}

func readItem(item *html.Node) *Item {
		if post := item.LastChild.PrevSibling; isDiv(post, "digest__home__post__content ") {
			if cs := post.FirstChild.NextSibling; isDiv(cs, "digest__home__post__content-inner") {
				if title := cs.FirstChild.NextSibling; isA(title, "digest__home__post__title") {
					if name := getChildren(title); isText(name[0]){
						return &Item{
							Ref:   getAttr(title, "href"),
							Title: name[0].Data,
						}
					}
				}
			}
	}
	return nil
}

func search(node *html.Node) []*Item {
	if isSection(node, "digest__posts") {
		var items []*Item
		for c := node.FirstChild; c != nil; c = c.NextSibling {
			if isArticle(c, "digest__home__post") {
				if item := readItem(c); item != nil {
					items = append(items, item)
				}
			}
		}
		return items
	}
	for c := node.FirstChild; c != nil; c = c.NextSibling {
		if items := search(c); items != nil {
			return items
		}
	}
	return nil
}

func downloadNews() []*Item {
	log.Info("sending request to jolt.law.harvard.edu/digest")
	if response, err := http.Get("http://jolt.law.harvard.edu/digest"); err != nil {
		log.Error("request to http://jolt.law.harvard.edu/digest failed", "error", err)
	} else {
		defer response.Body.Close()
		status := response.StatusCode
		log.Info("got response from http://jolt.law.harvard.edu/digest", "status", status)
		if status == http.StatusOK {
			if doc, err := html.Parse(response.Body); err != nil {
				log.Error("invalid HTML from http://jolt.law.harvard.edu/digest", "error", err)
			} else {
				log.Info("HTML from http://jolt.law.harvard.edu/digest parsed successfully")
				return search(doc)
			}
		}
	}
	return nil
}

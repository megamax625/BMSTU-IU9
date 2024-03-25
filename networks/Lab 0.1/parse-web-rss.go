package main

import (
	"encoding/xml"
	"errors"
	"fmt"
	"github.com/IzeBerg/rss-parser-go"
	"log"
	"net/http"
)

func InfoHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method is not supported", http.StatusNotFound)
	} else {
		fmt.Fprintf(w, "Use /parse?ref=sitename to access parsed rss feed\n codenames for sitenames:\n")
		fmt.Fprintf(w, "blagnews - \"http://blagnews.ru/rss_vk.xml\"\n")
		fmt.Fprintf(w, "rssboard - \"http://www.rssboard.org/files/sample-rss-2.xml\"\n")
		fmt.Fprintf(w, "lenta - \"https://lenta.ru/rss\"\n")
		fmt.Fprintf(w, "mail - \"https://news.mail.ru/rss/90/\"\n")
		fmt.Fprintf(w, "technolog - \"http://technolog.edu.ru/index.php?option=com_k2&view=itemlist&layout=category&task=category&id=8&lang=ru&format=feed\"\n")
		fmt.Fprintf(w, "vz - \"https://vz.ru/rss.xml\"\n")
		fmt.Fprintf(w, "appa or ap-pa - \"http://news.ap-pa.ru/rss.xml\"\n")
	} // отправляем данные на клиентскую сторону
}

func ParseHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method is not supported", http.StatusNotFound)
	} else {
		url := r.URL.Query().Get("ref")
		if url != "" {
			err := errors.New("wrong input")
			xmlname := xml.Name{
				Space: " ",
				Local: "",
			}
			rssObject := &rss.RSS{XMLName: xmlname, Version: `xml:"channel,attr"`}

			switch url {
			case "blagnews":
				rssObject, err = rss.ParseRSS("http://blagnews.ru/rss_vk.xml")
			case "rssboard":
				rssObject, err = rss.ParseRSS("http://www.rssboard.org/files/sample-rss-2.xml")
			case "lenta":
				rssObject, err = rss.ParseRSS("https://lenta.ru/rss")
			case "mail":
				rssObject, err = rss.ParseRSS("https://news.mail.ru/rss/90/")
			case "technolog":
				rssObject, err = rss.ParseRSS("http://technolog.edu.ru/index.php?option=com_k2&view=itemlist&layout=category&task=category&id=8&lang=ru&format=feed")
			case "vz":
				rssObject, err = rss.ParseRSS("https://vz.ru/rss.xml")
			case "ap-pa":
				fallthrough
			case "appa":
				rssObject, err = rss.ParseRSS("http://news.ap-pa.ru/rss.xml")
			default:
				err = errors.New("wrong input")
			}
			if err == nil {
				w.Header().Set("Content-Type", "text/html; charset=utf-8")
				fmt.Fprintf(w, "Title           : %s\n", rssObject.Channel.Title)
				fmt.Fprintf(w, "Generator       : %s\n", rssObject.Channel.Generator)
				fmt.Fprintf(w, "PubDate         : %s\n", rssObject.Channel.PubDate)
				fmt.Fprintf(w, "LastBuildDate   : %s\n", rssObject.Channel.LastBuildDate)
				fmt.Fprintf(w, "Description     : %s\n", rssObject.Channel.Description)

				fmt.Fprintf(w, "Number of Items : %d\n", len(rssObject.Channel.Items))

				for v := range rssObject.Channel.Items {
					item := rssObject.Channel.Items[v]
					fmt.Fprintf(w, "\n")
					fmt.Fprintf(w, "Item Number : %d\n", v)
					fmt.Fprintf(w, "Title       : %s\n", item.Title)
					fmt.Fprintf(w, "Link        : %s\n", item.Link)
					fmt.Fprintf(w, "Description : %s\n", item.Description)
					fmt.Fprintf(w, "Guid        : %s\n", item.Guid.Value)
				}
			} else {
				fmt.Fprintf(w, "Error: %s\n", err)
			}
		} else {
			fmt.Fprintf(w, "Wrong reference")
		}
	}
}

func main() {
	http.HandleFunc("/info", InfoHandler)
	http.HandleFunc("/parse", ParseHandler)  // установим роутер
	err := http.ListenAndServe(":9000", nil) // задаем слушать порт
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

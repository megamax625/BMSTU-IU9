package main

import (
	"encoding/xml"
	"errors"
	"fmt"
	"github.com/IzeBerg/rss-parser-go"
)

func main() {
	var num string
	err := errors.New("wrong input")
	fmt.Scan(&num)

	xmlname := xml.Name{
		Space: " ",
		Local: "",
	}
	rssObject := &rss.RSS{XMLName: xmlname, Version: `xml:"channel,attr"`}

	switch num {
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
	if err == nil{

		fmt.Printf("Title           : %s\n", rssObject.Channel.Title)
		fmt.Printf("Generator       : %s\n", rssObject.Channel.Generator)
		fmt.Printf("PubDate         : %s\n", rssObject.Channel.PubDate)
		fmt.Printf("LastBuildDate   : %s\n", rssObject.Channel.LastBuildDate)
		fmt.Printf("Description     : %s\n", rssObject.Channel.Description)

		fmt.Printf("Number of Items : %d\n", len(rssObject.Channel.Items))

		for v := range rssObject.Channel.Items {
			item := rssObject.Channel.Items[v]
			fmt.Println()
			fmt.Printf("Item Number : %d\n", v)
			fmt.Printf("Title       : %s\n", item.Title)
			fmt.Printf("Link        : %s\n", item.Link)
			fmt.Printf("Description : %s\n", item.Description)
			fmt.Printf("Guid        : %s\n", item.Guid.Value)
		}
	} else {
		fmt.Printf("Error: %s\n", err)
	}
}
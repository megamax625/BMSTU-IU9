package com.example.httpjson

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Toast
import androidx.appcompat.widget.AppCompatTextView

class ListAdapte (val context: Context, val list: ArrayList<MusicType>) : BaseAdapter() {
    override fun getCount(): Int {
        return list.size
    }

    override fun getItem(position: Int): Any {
        return list[position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getView(position: Int, countertView: View?, parent: ViewGroup?): View {

        val view: View = LayoutInflater.from(context).inflate(R.layout.row_layout,parent,false)
        val musictypeId = view.findViewById(R.id.musictype_Id) as AppCompatTextView
        val musictypeMusicType = view.findViewById(R.id.musictype_MusicType) as AppCompatTextView
        val musictypeUrl = view.findViewById(R.id.musictype_Url) as AppCompatTextView
        val musictypeGenre = view.findViewById(R.id.musictype_Genre) as AppCompatTextView

        musictypeId.text = list[position].id.toString()
        musictypeMusicType.text = list[position].MusicType
        musictypeUrl.text = list[position].Url
        musictypeGenre.text = list[position].Genre

        view.setOnClickListener {
            val toast = Toast.makeText(parent?.context, "MusicType: ${musictypeMusicType.text}\nGenre: ${musictypeGenre.text}\nID: ${musictypeId.text}", Toast.LENGTH_LONG)
            toast.show()
        }

        return view
    }
}
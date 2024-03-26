package com.example.kotlin_auth5_klicker_fb

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener


class MainActivity : AppCompatActivity() {

    var fbAuth = FirebaseAuth.getInstance()
    lateinit var _db: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var btnLogin = findViewById<Button>(R.id.btnLogin)
        btnLogin.setOnClickListener {view ->


            val myRef = FirebaseDatabase.getInstance(MYKEY).reference

            var a11: Double? = null
            var a12: Double? = null
            var a13: Double? = null
            var a21: Double? = null
            var a22: Double? = null
            var a23: Double? = null
            var a31: Double? = null
            var a32: Double? = null
            var a33: Double? = null
            // Read from the database
            myRef.addValueEventListener(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    // This method is called once with the initial value and again
                    // whenever data at this location is updated.
                    a11 = snapshot.child("a11").value.toString().toDouble()
                    a12 = snapshot.child("a12").value.toString().toDouble()
                    a13 = snapshot.child("a13").value.toString().toDouble()
                    a21 = snapshot.child("a21").value.toString().toDouble()
                    a22 = snapshot.child("a22").value.toString().toDouble()
                    a23 = snapshot.child("a23").value.toString().toDouble()
                    a31 = snapshot.child("a31").value.toString().toDouble()
                    a32 = snapshot.child("a32").value.toString().toDouble()
                    a33 = snapshot.child("a33").value.toString().toDouble()

                    val A = arrayOf(arrayOf(a11, a12, a13),
                        arrayOf(a21, a22, a23),
                        arrayOf(a31, a32, a33))

                    val vec = arrayOf(findViewById<EditText>(R.id.val1).text.toString().toDouble(),
                        findViewById<EditText>(R.id.val2).text.toString().toDouble(), findViewById<EditText>(R.id.val3).text.toString().toDouble())


                    val res = multiplyMatrices(A, vec)
                    var tv = findViewById<TextView>(R.id.res1)
                    tv.text = res[0].toString()
                    tv = findViewById<TextView>(R.id.res2)
                    tv.text = res[1].toString()
                    tv = findViewById<TextView>(R.id.res3)
                    tv.text = res[2].toString()
                }

                override fun onCancelled(error: DatabaseError) {
                    print("fail")
                }

            })


        }
    }


    fun multiplyMatrices(
        matrix: Array<Array<Double?>>,
        vector: Array<Double>,
    ): Array <Double> {
        val product = arrayOf(0.0, 0.0, 0.0)
        for (i in 0..2) {
            for (j in 0..2) {
                product[i] = product[i] + (matrix[i][j]?.times(vector[j]) ?: 0.0)
            }
        }

        return product
    }
}

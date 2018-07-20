using UnityEngine;
using System.Collections;

public class WebcamCapture : MonoBehaviour
{
    

    private static WebCamTexture webcamtex;

    private void Awake()
    {
        webcamtex = new WebCamTexture();
    }

    void Start()
    {
           //コンストラクタ
        Renderer _renderer = GetComponent<Renderer>();  //Planeオブジェクトのレンダラ
        _renderer.material.mainTexture = webcamtex;    //mainTextureにWebCamTextureを指定
        webcamtex.Play();  //ウェブカムを作動させる
    }

}
using UnityEngine;
using UnityEngine.UI;

public class WebcamCapture : MonoBehaviour
{
    private static WebCamTexture webcamtex;
    private float ratio;

    private void Awake()
    {
        
        webcamtex = new WebCamTexture();
        if (GetComponent<Renderer>())
        {
            Renderer _renderer = GetComponent<Renderer>();  //Planeオブジェクトのレンダラ
            _renderer.material.mainTexture = webcamtex;    //mainTextureにWebCamTextureを指定
        }
        else {
            RawImage ima = GetComponent<RawImage>();
            ima.material.mainTexture = webcamtex;
        }
        webcamtex.filterMode = FilterMode.Bilinear;
        webcamtex.Play();  //ウェブカムを作動させる
    }
    private void Start()
    {
        webcamtex.requestedHeight = Screen.currentResolution.height;
        webcamtex.requestedWidth = Screen.currentResolution.width;
        webcamtex.requestedFPS = 60;
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
    }
    private void Update()
    {
        if (webcamtex.isPlaying)
        {
            ratio = (float)webcamtex.width / (float)webcamtex.height;
            transform.localScale = new Vector3(2 * ratio, 2, 1);
        }
    }
}
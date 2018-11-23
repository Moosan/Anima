using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class NKWebCamTexture : MonoBehaviour {
    public RawImage rawImage;

    private RectMask2D rectMask;
    private WebCamTexture webCamTexture;

    /*---------------------------*
	 * Default Method
	 *---------------------------*/
    // Use this for initialization
    void Start()
    {
        //カメラの初期化
        initWebCamTexture();
    }

    // Update is called once per frame
    void Update()
    {

    }

    /*---------------------------*
	 * Load Method
	 *---------------------------*/
    //WebCamTextureの初期化
    private void initWebCamTexture()
    {
        if (rawImage)
        {
            if (!rectMask)
            {
                //RectMask2Dの初期化
                initRectMask2D();
            }

            //Webカメラの取得
            if (WebCamTexture.devices.Length > 0)
            {
                //Webカメラ情報の取得
                WebCamDevice webCamDevice = WebCamTexture.devices[0];

                //WebCamTextureの作成
                RectTransform maskTransform = rectMask.GetComponent<RectTransform>();
                webCamTexture = new WebCamTexture(webCamDevice.name, (int)maskTransform.sizeDelta.x, (int)maskTransform.sizeDelta.y);

                //WebCamTextureをrawImageで表示する
                rawImage.material.mainTexture = webCamTexture;

                //WebCamTextureの撮影開始
                webCamTexture.Play();

                StartCoroutine("waitWebCamFrame");
            }
            else
            {
                Debug.LogError("Webカメラが認識できません");
            }
        }
        else
        {
            Debug.LogError("RawImageが指定されていません");
        }
    }

    //カメラの画像が読み込まれるのを待つ
    private IEnumerator waitWebCamFrame()
    {
        while (true)
        {
            yield return new WaitForSeconds(0.2f);
            if (webCamTexture.isPlaying)
            {
                if (webCamTexture.didUpdateThisFrame)
                {
                    //rawImageの比率を修正
                    RectTransform rawImageTransform = rawImage.GetComponent<RectTransform>();
                    Vector2 maskVector2 = rectMask.GetComponent<RectTransform>().sizeDelta;
                    float width = webCamTexture.width;
                    float height = webCamTexture.height;
                    if (width > height)
                    {
                        //横長の場合は縦を基準に横に伸ばす
                        height = maskVector2.y;
                        width = (maskVector2.y / maskVector2.x) * webCamTexture.width;
                    }
                    else
                    {
                        //縦長の場合は横を基準に縦に伸ばす
                        width = maskVector2.x;
                        height = (maskVector2.x / maskVector2.y) * webCamTexture.height;
                    }
                    rawImageTransform.sizeDelta = new Vector2(width, height);
                    break;
                }
            }
        }
    }

    //RectMask2Dの初期化
    private void initRectMask2D()
    {
        if (!rectMask)
        {
            if (rawImage)
            {
                //rawImageの親がRectMask2Dか判別
                if (rawImage.transform.parent.GetComponent<RectMask2D>())
                {
                    //rawImageの親がRectMask2D
                    rectMask = rawImage.transform.parent.GetComponent<RectMask2D>();
                }
                else
                {
                    //rawImageの親がRectMask2Dじゃないので作成する
                    GameObject rectMask2D = new GameObject("NKWebCamTextureMask");
                    rectMask2D.transform.SetParent(rawImage.transform.parent);
                    rectMask2D.AddComponent<RectMask2D>();
                    //RectMask2Dの位置はrawImageを元に設定
                    RectTransform maskTransform = rectMask2D.GetComponent<RectTransform>();
                    RectTransform rawImageTransform = rawImage.GetComponent<RectTransform>();
                    maskTransform.sizeDelta = rawImageTransform.sizeDelta;
                    maskTransform.rotation = rawImageTransform.rotation;
                    maskTransform.position = rawImageTransform.position;
                    maskTransform.pivot = rawImageTransform.pivot;
                    maskTransform.offsetMin = rawImageTransform.offsetMin;
                    maskTransform.offsetMax = rawImageTransform.offsetMax;
                    rawImage.transform.SetParent(rectMask2D.transform);
                    rectMask = rectMask2D.GetComponent<RectMask2D>();
                }
            }
            else
            {
                Debug.LogError("RawImageが指定されていません");
            }
        }
    }
}

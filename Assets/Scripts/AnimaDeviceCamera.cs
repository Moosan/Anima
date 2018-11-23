using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AnimaDeviceCamera : MonoBehaviour {

    private RawImage cameraImage;
    private WebCamTexture webCamTexture;
    private AspectRatioFitter animaAspectRatioFitter;
    [SerializeField]
    private int cameraIndex;
    private int thisWidth;
    private int thisHeight;

    void Awake()
    {
        cameraImage = GetComponent<RawImage>();
        animaAspectRatioFitter = GetComponent<AspectRatioFitter>();
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
    }

    void Start()
    {
        //StartCoroutine("cameraStart");
        thisWidth = Screen.currentResolution.width;
        thisHeight = Screen.currentResolution.height;
        webCamTexture = new WebCamTexture(WebCamTexture.devices[cameraIndex].name, thisWidth, thisHeight, 60);
        cameraImage.texture = webCamTexture;
        webCamTexture.Play();
    }

    private void Update()
    {

        thisWidth = Screen.currentResolution.width;
        thisHeight = Screen.currentResolution.height;
        float ratio = (float)thisHeight / (float)thisWidth;
        animaAspectRatioFitter.aspectRatio = ratio;
        if (webCamTexture.isPlaying)
        {
            transform.localEulerAngles = new Vector3(0, 0, -1 * (float)webCamTexture.videoRotationAngle);
        }
    }
}

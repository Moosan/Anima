using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DeviceCamera : MonoBehaviour {

    private RawImage cameraImage;
    private WebCamTexture webCamTexture;
    private AspectRatioFitter aspectRatioFitter;

    void Awake()
    {
        cameraImage = GetComponent<RawImage>();
        aspectRatioFitter = GetComponent<AspectRatioFitter>();
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
    }

    void Start()
    {
        webCamTexture = new WebCamTexture(Screen.currentResolution.width, Screen.currentResolution.height, 60);
        cameraImage.texture = webCamTexture;
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            cameraImage.rectTransform.localScale = new Vector3(1, -1, 1);
        }
        webCamTexture.Play();
    }

    private void Update()
    {
        if (webCamTexture.isPlaying)
        {
            transform.localEulerAngles = new Vector3(0, 0, -1 * (float)webCamTexture.videoRotationAngle);
            aspectRatioFitter.aspectRatio = (float)webCamTexture.width / (float)webCamTexture.height;
        }
    }
}

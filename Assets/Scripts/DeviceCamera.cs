using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DeviceCamera : MonoBehaviour {

    private RawImage cameraImage;
    private WebCamTexture webCamTexture;
    private AspectRatioFitter cameraAspectRatioFitter;
    private AspectRatioFitter animaAspectRatioFitter;
    [SerializeField]
    private int cameraIndex;
    [SerializeField]
    private RawImage animaImage;
    [SerializeField]
    private Camera objCamera;
    [SerializeField]
    private Camera videoCamera;

    private int thisWidth;
    private int thisHeight;

    void Awake()
    {
        cameraImage = GetComponent<RawImage>();
        cameraAspectRatioFitter = GetComponent<AspectRatioFitter>();
        animaAspectRatioFitter = animaImage.GetComponent<AspectRatioFitter>();
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
    }

    void Start()
    {
        //StartCoroutine("cameraStart");
        thisWidth = Screen.currentResolution.width;
        thisHeight = Screen.currentResolution.height;
        webCamTexture = new WebCamTexture(WebCamTexture.devices[cameraIndex].name, thisWidth, thisHeight, 60);
        cameraImage.texture = webCamTexture;
        /*
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            cameraImage.rectTransform.localScale = new Vector3(1, -1, 1);
        }
        */
        webCamTexture.Play();

        animaImage.texture.height = thisWidth;
        animaImage.texture.width = thisHeight;
    }
    
    private void Update()
    {

        thisWidth = Screen.currentResolution.width;
        thisHeight = Screen.currentResolution.height;
        float ratio = (float)thisHeight / (float)thisWidth;
        cameraAspectRatioFitter.aspectRatio = ratio;
        animaAspectRatioFitter.aspectRatio = ratio;
        /*if (webCamTexture.isPlaying)
        {
            transform.localEulerAngles = new Vector3(0, 0, -1 * (float)webCamTexture.videoRotationAngle);
        }*/
    }
}

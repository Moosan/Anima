using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GyroRotate : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        Input.gyro.enabled = true;
    }

    // Update is called once per frame
    void Update()
    {
        transform.rotation = Quaternion.AngleAxis(90.000000f, Vector3.right) * Input.gyro.attitude * Quaternion.AngleAxis(180.000000f, Vector3.forward);
    }
}
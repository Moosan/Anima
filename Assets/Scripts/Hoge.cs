using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows.Speech;
using UnityEngine.UI;
public class Hoge : MonoBehaviour
{
    [SerializeField]
    private Text m_Recognitions;

    [SerializeField]
    private GameObject panel;

    [SerializeField]
    private float time;

    private DictationRecognizer m_DictationRecognizer;

    void Start()
    {
        panel.transform.localScale = new Vector3(1, 1, 0);
        m_DictationRecognizer = new DictationRecognizer
        {
            InitialSilenceTimeoutSeconds = time,
            AutoSilenceTimeoutSeconds = time
        };

        //panel.SetActive(false);
        m_DictationRecognizer.DictationResult += (text, confidence) =>
        {
            //panel.SetActive(true);
            //Debug.LogFormat("Dictation result: {0}", text);
            m_Recognitions.text = text;
        };
        
        m_DictationRecognizer.DictationHypothesis += (text) =>
        {
            panel.transform.localScale = new Vector3(1, 1, 1);
            //Debug.LogFormat("Dictation hypothesis: {0}", text);
            m_Recognitions.text = text;
            //Debug.Log(text);
        };
        
        m_DictationRecognizer.DictationComplete += (completionCause) =>
        {
            //panel.SetActive(false);
            if (completionCause != DictationCompletionCause.Complete)
            {
                //Debug.LogErrorFormat("Dictation completed unsuccessfully: {0}.", completionCause);
            }
            if (completionCause == DictationCompletionCause.TimeoutExceeded|| completionCause == DictationCompletionCause.Complete)
            {
                m_DictationRecognizer.Start();
            }
        };

        m_DictationRecognizer.DictationError += (error, hresult) =>
        {
            //Debug.LogErrorFormat("Dictation error: {0}; HResult = {1}.", error, hresult);
        };

        m_DictationRecognizer.Start();
    }
}

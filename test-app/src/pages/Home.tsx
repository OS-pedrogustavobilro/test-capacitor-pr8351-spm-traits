import { IonButton, IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import { useState } from 'react';
import { PluginWithTraits } from '@ospedrobilro/cap-plugin-with-traits';
import ExploreContainer from '../components/ExploreContainer';
import './Home.css';

const Home: React.FC = () => {
  const [echoResult, setEchoResult] = useState<string>('');

  const handleEcho = async () => {
    try {
      const result = await PluginWithTraits.echo({ value: 'Hello from Capacitor with Traits!' });
      setEchoResult(result.value);
      console.log('Echo result:', result.value);
    } catch (error) {
      console.error('Error calling echo:', error);
      setEchoResult('Error: ' + (error as Error).message);
    }
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Traits Test App</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Traits Test</IonTitle>
          </IonToolbar>
        </IonHeader>
        <div style={{ padding: '20px' }}>
          <IonButton expand="block" onClick={handleEcho}>
            Test Echo with Traits
          </IonButton>
          {echoResult && (
            <div style={{ marginTop: '20px', padding: '15px', background: '#f4f4f4', borderRadius: '8px' }}>
              <strong>Echo Result:</strong>
              <p>{echoResult}</p>
            </div>
          )}
        </div>
        <ExploreContainer />
      </IonContent>
    </IonPage>
  );
};

export default Home;

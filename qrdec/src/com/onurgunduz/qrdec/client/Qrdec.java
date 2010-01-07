package com.onurgunduz.qrdec.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.RootPanel;
import com.google.gwt.user.client.ui.HTML;

import com.onurgunduz.qrdec.client.BitMatrix;;

public class Qrdec implements EntryPoint {

  private static void decode(int[][] source) throws ReaderException
  {
	  
	  int dimension = source.length;
	  BitMatrix bits = new BitMatrix(dimension);
	  
	  for( int k = 0; k < dimension; k++ )
	  {
		  for( int v = 0; v < dimension; v++)
		  {
			  if(source != null)
			  {
				  if(source[k][v] == 1)
				  {
					  bits.set(k, v);
				  }
			  }
		  }
	  }
	  
	  Decoder decoder = new Decoder();
	  DecoderResult decoderResult = decoder.decode(bits);

	  String decodedString = decoderResult.getText();
	  
	  RootPanel.get("resultView").clear();
	  RootPanel.get("resultView").add(new HTML("<h2>Decoded string:</h2>"));
	  RootPanel.get("resultView").add(new HTML("<p class='decoded'>" + decodedString +"</p>"));
  }
  
  private native void publish()
  /*-{
	$wnd.decode =  @com.onurgunduz.qrdec.client.Qrdec::decode([[I);
  }-*/;
  
  public void onModuleLoad()
  {
	  publish();
  }
  
 }